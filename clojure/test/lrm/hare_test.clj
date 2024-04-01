;; SPDX-FileCopyrightText: 2024 Denis Danilov
;; SPDX-License-Identifier: MIT

(ns lrm.hare-test
  (:require [clojure.test :refer [deftest is testing]]
            [lrm.hare :as T]))

(deftest input-data
  (testing "input data"
    (let [data (T/read-data "resources/data.txt")
          seats (first data)
          votes (second data)]
      (is (= seats 123))
      (is (= (count votes) 2))
      (is (= (votes "party_A") 10))
      (is (= (votes "party_B") 11)))))

(deftest quota-distribution
  (testing "quota distribution"
    (testing "with empty votes"
      (is (= (T/distribute-quota [0 {}])
             [0 []]))
      (is (= (T/distribute-quota [1 {}])
             [1 []])))
    (testing "with zero seats"
      (is (= (T/distribute-quota [0 {"A" 1}])
             [0 [["A" 0 0]]]))
      (is (= (T/distribute-quota [0 {"A" 1, "B" 2, "C" 3}])
             [0 [["A" 0 0] ["B" 0 0] ["C" 0 0]]])))
    (testing "without rest"
      (testing "equal distribution"
        (is (= (T/distribute-quota [300 {"A" 10, "B" 10, "C" 10}])
               [0 [["A" 100 0] ["B" 100 0] ["C" 100 0]]])))
      (testing "proportional distribution"
        (is (= (T/distribute-quota [300 {"A" 1, "B" 2, "C" 3}])
               [0 [["A" 50 0] ["B" 100 0] ["C" 150 0]]]))))
    (testing "with rest"
      (is (= (T/distribute-quota [301 {"A" 1, "B" 2, "C" 3}])
             [1 [["A" 50 1] ["B" 100 2] ["C" 150 3]]])))))
