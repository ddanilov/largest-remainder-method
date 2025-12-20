! SPDX-FileCopyrightText: 2025 Denis Danilov
! SPDX-License-Identifier: GPL-3.0-only

module test_read_data

   use testdrive, only: new_unittest, unittest_type, error_type, check
   use lrm, only: votes_type, read_data

   implicit none

   public :: collect_read_data

contains

   subroutine collect_read_data(testsuite)
      type(unittest_type), allocatable, intent(out) :: testsuite(:)

      testsuite = [ &
                  new_unittest("empty input", test_01), &
                  new_unittest("seats only", test_02), &
                  new_unittest("single party", test_03), &
                  new_unittest("two parties with seats", test_04), &
                  new_unittest("large data", test_05) &
                  ]

   end subroutine collect_read_data

   subroutine test_01(error)
      type(error_type), allocatable, intent(out) :: error
      integer :: test_data_unit
      type(votes_type), dimension(:), allocatable :: data
      integer :: seats

      open (newunit=test_data_unit, status='scratch')

      call read_data(test_data_unit, data, seats)

      close (test_data_unit)

      call check(error, allocated(data))
      call check(error, size(data), 0)
      call check(error, seats, 0)

   end subroutine test_01

   subroutine test_02(error)
      type(error_type), allocatable, intent(out) :: error
      integer :: test_data_unit
      type(votes_type), dimension(:), allocatable :: data
      integer :: seats

      open (newunit=test_data_unit, status='scratch')
      write (test_data_unit, '(a)') 'seats   123'
      rewind (test_data_unit)

      call read_data(test_data_unit, data, seats)

      close (test_data_unit)

      call check(error, allocated(data))
      call check(error, size(data), 0)
      call check(error, seats, 123)

   end subroutine test_02

   subroutine test_03(error)
      type(error_type), allocatable, intent(out) :: error
      integer :: test_data_unit
      type(votes_type), dimension(:), allocatable :: data
      integer :: seats

      open (newunit=test_data_unit, status='scratch')
      write (test_data_unit, '(a)') 'party_A 10'
      rewind (test_data_unit)

      call read_data(test_data_unit, data, seats)

      close (test_data_unit)

      call check(error, allocated(data))
      call check(error, size(data), 1)
      call check(error, seats, 0)

      call check(error, data(1)%name, 'party_A')
      call check(error, data(1)%votes, 10)

   end subroutine test_03

   subroutine test_04(error)
      type(error_type), allocatable, intent(out) :: error
      integer :: test_data_unit
      type(votes_type), dimension(:), allocatable :: data
      integer :: seats

      open (newunit=test_data_unit, status='scratch')
      write (test_data_unit, '(a)') 'seats   123'
      write (test_data_unit, '(a)') 'party_A 10'
      write (test_data_unit, '(a)') 'party_B 11'
      rewind (test_data_unit)

      call read_data(test_data_unit, data, seats)

      close (test_data_unit)

      call check(error, allocated(data))
      call check(error, size(data), 2)
      call check(error, seats, 123)

      call check(error, data(1)%name, 'party_A')
      call check(error, data(1)%votes, 10)

      call check(error, data(2)%name, 'party_B')
      call check(error, data(2)%votes, 11)

   end subroutine test_04

   subroutine test_05(error)
      type(error_type), allocatable, intent(out) :: error
      integer :: test_data_unit
      type(votes_type), dimension(:), allocatable :: data
      integer :: seats

      integer, parameter :: num_items = 100
      integer :: i
      character(len=20) :: tmp

      open (newunit=test_data_unit, status='scratch')
      do i = 1, num_items, 1
         write (tmp, '(A,I3.3)') 'data_', i ! 'data_001' ... 'data_100'
         write (test_data_unit, '(A,3X,I0)') trim(tmp), i
      end do
      rewind (test_data_unit)

      call read_data(test_data_unit, data, seats)

      close (test_data_unit)

      call check(error, allocated(data))
      call check(error, size(data), num_items)

      call check(error, data(1)%name, 'data_001')
      call check(error, data(1)%votes, 1)

      call check(error, data(2)%name, 'data_002')
      call check(error, data(2)%votes, 2)

      call check(error, data(num_items)%name, 'data_100')
      call check(error, data(num_items)%votes, num_items)

   end subroutine test_05

end module test_read_data
