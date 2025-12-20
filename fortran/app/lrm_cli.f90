! SPDX-FileCopyrightText: 2025 Denis Danilov
! SPDX-License-Identifier: GPL-3.0-only

program main
   use, intrinsic :: iso_fortran_env, only: output_unit
   use lrm

   implicit none

   integer :: arg_count
   integer :: io_unit
   character(len=256) :: input_file

   type(votes_type), dimension(:), allocatable :: data
   integer :: seats
   integer :: rest

   arg_count = command_argument_count()
   if (arg_count /= 1) then
      stop 'wrong number of arguments'
   end if

   call get_command_argument(1, input_file)
   open (newunit=io_unit, file=trim(input_file), status='old')
   call read_data(io_unit, data, seats)
   close (io_unit)

   write (output_unit, '(A)') '============ QUOTA ============='
   call distribute_quota(data, seats, rest)
   call print_results(data)
   write (output_unit, '(A, I0)') 'rest: ', rest

   write (output_unit, '(A)') '============ FINAL ============='
   call distribute_rest(data, rest)
   call print_results(data)

contains

   subroutine print_results(data)
      type(votes_type), dimension(:), allocatable, intent(in) :: data

      character(len=10), parameter :: name = 'name'

      logical, dimension(:), allocatable :: index_mask
      integer :: i, i_max

      allocate (index_mask(size(data)), source=.true.)

      write (output_unit, '(A10, 1X, A10, 1X, A10)') adjustl(name), 'result', 'remainder'
      do i = 1, size(data)
         i_max = maxloc(data%quota, dim=1, mask=index_mask)
         index_mask(i_max) = .false.
         write (output_unit, '(A10, 1X, I10, 1X, I10)') adjustl(data(i_max)%name), data(i_max)%quota, data(i_max)%remainder
      end do

   end subroutine print_results

end program main
