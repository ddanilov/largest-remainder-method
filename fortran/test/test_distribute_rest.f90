! SPDX-FileCopyrightText: 2025 Denis Danilov
! SPDX-License-Identifier: GPL-3.0-only

module test_distribute_rest

   use testdrive, only: new_unittest, unittest_type, error_type, check
   use lrm, only: votes_type, distribute_rest

   implicit none

   public :: collect_distribute_rest

contains

   subroutine collect_distribute_rest(testsuite)
      type(unittest_type), allocatable, intent(out) :: testsuite(:)

      testsuite = [ &
                  new_unittest("one", test_01), &
                  new_unittest("two", test_02), &
                  new_unittest("three", test_03) &
                  ]

   end subroutine collect_distribute_rest

   subroutine test_01(error)
      type(error_type), allocatable, intent(out) :: error
      type(votes_type), dimension(:), allocatable :: data

      allocate (data(3))

      data(1)%name = 'A'
      data(1)%quota = 300
      data(1)%remainder = 1

      data(2)%name = 'B'
      data(2)%quota = 200
      data(2)%remainder = 2

      data(3)%name = 'C'
      data(3)%quota = 100
      data(3)%remainder = 3

      call distribute_rest(data, 1)

      call check(error, data(1)%quota, 300)
      call check(error, data(2)%quota, 200)
      call check(error, data(3)%quota, 101)

   end subroutine test_01

   subroutine test_02(error)
      type(error_type), allocatable, intent(out) :: error
      type(votes_type), dimension(:), allocatable :: data

      allocate (data(3))

      data(1)%name = 'A'
      data(1)%quota = 300
      data(1)%remainder = 1

      data(2)%name = 'B'
      data(2)%quota = 200
      data(2)%remainder = 2

      data(3)%name = 'C'
      data(3)%quota = 100
      data(3)%remainder = 3

      call distribute_rest(data, 2)

      call check(error, data(1)%quota, 300)
      call check(error, data(2)%quota, 201)
      call check(error, data(3)%quota, 101)

   end subroutine test_02

   subroutine test_03(error)
      type(error_type), allocatable, intent(out) :: error
      type(votes_type), dimension(:), allocatable :: data

      allocate (data(3))

      data(1)%name = 'A'
      data(1)%quota = 300
      data(1)%remainder = 1

      data(2)%name = 'B'
      data(2)%quota = 200
      data(2)%remainder = 2

      data(3)%name = 'C'
      data(3)%quota = 100
      data(3)%remainder = 3

      call distribute_rest(data, 3)

      call check(error, data(1)%quota, 301)
      call check(error, data(2)%quota, 201)
      call check(error, data(3)%quota, 101)

   end subroutine test_03

end module test_distribute_rest
