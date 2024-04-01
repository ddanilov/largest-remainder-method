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

(defn distribute-rest [[res quotas]]
  (loop [i 0, xs (vec (sort-by #(nth % 2) > quotas))]
    (if (= i res) xs
        (recur (inc i), (update-in xs [i 1] inc)))))

(defn print-results [data]
  (let [print-line (fn [v1 v2 v3] (println (format "%-10s %10s %10s" (str v1) (str v2) (str v3))))]
    (print-line "name" "result" "remainder")
    (doseq [[v1 v2 v3] (sort-by second > data)]
      (print-line v1 v2 v3))))

(defn -main [filename]
  (let [d (read-data filename)
        q (distribute-quota d)
        f (distribute-rest q)]
    (println "============ QUOTA =============")
    (print-results (second q))
    (println (format "rest: %d" (first q)))
    (println "============ FINAL =============")
    (print-results f)))
