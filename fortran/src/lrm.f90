! SPDX-FileCopyrightText: 2025 Denis Danilov
! SPDX-License-Identifier: GPL-3.0-only

module lrm

   implicit none
   private

   public :: votes_type
   public :: read_data, distribute_quota, distribute_rest

   integer, parameter :: key_length = 200

   type :: votes_type
      character(len=key_length) :: name = ''
      integer :: votes = 0
      integer :: quota = 0
      integer :: remainder = 0
   end type votes_type

contains

   subroutine read_data(input_unit, data, seats)
      integer, intent(in) :: input_unit
      type(votes_type), dimension(:), allocatable, intent(out) :: data
      integer, intent(out) :: seats

      character(len=key_length) :: key
      integer :: val
      integer :: io_stat

      type(votes_type), dimension(:), allocatable :: buffer
      integer :: buffer_size
      integer :: i

      buffer_size = expand_allocatable(buffer)

      seats = 0
      i = 0
      do
         read (input_unit, *, iostat=io_stat) key, val
         if (io_stat /= 0) exit

         if (trim(key) == 'seats') then
            seats = val
            cycle
         end if

         i = i + 1
         if (i > buffer_size) then
            buffer_size = expand_allocatable(buffer)
         end if

         buffer(i)%name = trim(key)
         buffer(i)%votes = val
      end do

      if (i == 0) then
         allocate (data(0))
      else
         data = buffer(1:i)
      end if

   end subroutine read_data

   subroutine distribute_quota(data, seats, rest)
      type(votes_type), dimension(:), allocatable, intent(inout) :: data
      integer, intent(in) :: seats
      integer, intent(out) :: rest

      integer :: total_votes
      integer :: total_quota

      total_votes = sum(data%votes)
      if (total_votes /= 0) then
         data%quota = (data%votes*seats)/total_votes
         data%remainder = mod(data%votes*seats, total_votes)
      end if

      total_quota = sum(data%quota)
      rest = seats - total_quota

   end subroutine distribute_quota

   subroutine distribute_rest(data, rest)
      type(votes_type), dimension(:), allocatable, intent(inout) :: data
      integer, intent(in) :: rest

      logical, dimension(:), allocatable :: index_mask
      integer :: i, i_max

      allocate (index_mask(size(data)), source=.true.)

      do i = 1, rest
         i_max = maxloc(data%remainder, dim=1, mask=index_mask)
         index_mask(i_max) = .false.
         data(i_max)%quota = data(i_max)%quota + 1
      end do

   end subroutine distribute_rest

   integer function expand_allocatable(data) result(new_size)
      type(votes_type), dimension(:), allocatable, intent(inout) :: data

      type(votes_type), dimension(:), allocatable :: tmp
      integer :: old_size
      integer, parameter :: initial_size = 16

      if (.not. allocated(data)) then
         old_size = 0
      else
         old_size = size(data)
      end if

      new_size = max(2*old_size, initial_size)
      allocate (tmp(new_size))

      if (old_size > 0) then
         tmp(1:old_size) = data
      end if

      call move_alloc(from=tmp, to=data)

   end function expand_allocatable

end module lrm
