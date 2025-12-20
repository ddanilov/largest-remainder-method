! SPDX-FileCopyrightText: 2025 Denis Danilov
! SPDX-License-Identifier: GPL-3.0-only

program test_runner
   use, intrinsic :: iso_fortran_env, only: error_unit
   use testdrive, only: run_testsuite, new_testsuite, testsuite_type

   implicit none

   integer :: stat, is
   type(testsuite_type), allocatable :: testsuites(:)

   stat = 0
   allocate (testsuites(0))

   do is = 1, size(testsuites)
      write (error_unit, '("Testing:", 1x, a)') testsuites(is)%name
      call run_testsuite(testsuites(is)%collect, error_unit, stat)
   end do

   if (stat > 0) then
      write (error_unit, '(i0, 1x, a)') stat, "test(s) failed!"
      error stop
   end if

end program test_runner
