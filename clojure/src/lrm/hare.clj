;; SPDX-FileCopyrightText: 2024 Denis Danilov
;; SPDX-License-Identifier: MIT

(ns lrm.hare
  (:require [clojure.string :as string]))

(defn read-data [file-name]
  (let [data (->> (slurp file-name)
                  (string/split-lines ,,)
                  (map #(string/split % #" ") ,,)
                  (map (juxt first (comp parse-long second)) ,,)
                  (into {} ,,))
        seats (data "seats")
        votes (dissoc data "seats")]
    [seats votes]))

(defn distribute-quota [[seats votes]]
  (let [total (reduce + (vals votes))
        q #(quot (* (val %) seats) total)
        r #(rem (* (val %) seats) total)
        qs (mapv (juxt key q r) votes)
        sum (reduce + (map second qs))
        res (- seats sum)]
    [res qs]))
