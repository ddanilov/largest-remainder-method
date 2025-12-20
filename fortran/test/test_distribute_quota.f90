! SPDX-FileCopyrightText: 2025 Denis Danilov
! SPDX-License-Identifier: GPL-3.0-only

module test_distribute_quota

   use testdrive, only: new_unittest, unittest_type, error_type, check
   use lrm, only: votes_type, distribute_quota

   implicit none

   public :: collect_distribute_quota

contains

   subroutine collect_distribute_quota(testsuite)
      type(unittest_type), allocatable, intent(out) :: testsuite(:)

      testsuite = [ &
                  new_unittest("with empty votes", test_01), &
                  new_unittest("with zero seats", test_02), &
                  new_unittest("without rest", test_03), &
                  new_unittest("with rest", test_04) &
                  ]

   end subroutine collect_distribute_quota

   subroutine test_01(error)
      type(error_type), allocatable, intent(out) :: error
      type(votes_type), dimension(:), allocatable :: data
      integer :: rest

      allocate (data(0))

      call distribute_quota(data, 0, rest)
      call check(error, rest, 0)

      call distribute_quota(data, 1, rest)
      call check(error, rest, 1)

   end subroutine test_01

   subroutine test_02(error)
      type(error_type), allocatable, intent(out) :: error
      type(votes_type), dimension(:), allocatable :: data
      integer :: rest

      allocate (data(3))

      data(1)%name = 'A'
      data(1)%votes = 1

      data(2)%name = 'B'
      data(2)%votes = 2

      data(3)%name = 'C'
      data(3)%votes = 3

      call distribute_quota(data, 0, rest)

      call check(error, rest, 0)

      call check(error, data(1)%quota, 0)
      call check(error, data(2)%quota, 0)
      call check(error, data(3)%quota, 0)

   end subroutine test_02

   subroutine test_03(error)
      type(error_type), allocatable, intent(out) :: error
      type(votes_type), dimension(:), allocatable :: data
      integer :: rest

      allocate (data(3))

      data(1)%name = 'A'
      data(1)%votes = 10

      data(2)%name = 'B'
      data(2)%votes = 10

      data(3)%name = 'C'
      data(3)%votes = 10

      call distribute_quota(data, 300, rest)

      call check(error, rest, 0)

      call check(error, data(1)%quota, 100)
      call check(error, data(2)%quota, 100)
      call check(error, data(3)%quota, 100)

      data(1)%name = 'A'
      data(1)%votes = 1

      data(2)%name = 'B'
      data(2)%votes = 2

      data(3)%name = 'C'
      data(3)%votes = 3

      call distribute_quota(data, 300, rest)

      call check(error, rest, 0)

      call check(error, data(1)%quota, 50)
      call check(error, data(2)%quota, 100)
      call check(error, data(3)%quota, 150)

   end subroutine test_03

   subroutine test_04(error)
      type(error_type), allocatable, intent(out) :: error
      type(votes_type), dimension(:), allocatable :: data
      integer :: rest

      allocate (data(3))

      data(1)%name = 'A'
      data(1)%votes = 1

      data(2)%name = 'B'
      data(2)%votes = 2

      data(3)%name = 'C'
      data(3)%votes = 3

      call distribute_quota(data, 301, rest)

      call check(error, rest, 1)

      call check(error, data(1)%quota, 50)
      call check(error, data(2)%quota, 100)
      call check(error, data(3)%quota, 150)

   end subroutine test_04

end module test_distribute_quota
