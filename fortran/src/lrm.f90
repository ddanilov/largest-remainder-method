! SPDX-FileCopyrightText: 2025 Denis Danilov
! SPDX-License-Identifier: GPL-3.0-only

module lrm

   implicit none
   private

   public :: votes_type
   public :: read_data

   integer, parameter :: key_length = 200

   type :: votes_type
      character(len=key_length) :: name = ''
      integer :: votes = 0
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
      integer :: i

      allocate (buffer(10))

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
         buffer(i)%name = trim(key)
         buffer(i)%votes = val
      end do

      if (i == 0) then
         allocate (data(0))
      else
         data = buffer(1:i)
      end if

   end subroutine read_data

end module lrm
