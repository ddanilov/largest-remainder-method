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
