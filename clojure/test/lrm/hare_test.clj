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
