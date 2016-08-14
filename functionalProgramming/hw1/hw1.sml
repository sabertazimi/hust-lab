(* Hello Standard ML! *)

(* fun expressions *)

fun swap(pairs: int*bool) =
  (#2 pairs, #1 pairs)

fun sum_two_paris(pairs1: int*int, pairs2: int*int) =
  (#1 pairs1) + (#2 pairs1) + (#1 pairs2) + (#2 pairs2)

fun div_mod(x: int, y: int) =
  (x div y, x mod y)

fun sort_pair(pr: int*int) =
  if (#1 pr) < (#2 pr)
  then pr
  else (#2 pr, #1 pr)

fun sum_list(xs: int list) =
  if null xs
  then 0
  else hd xs + sum_list(tl xs)

fun product_list(xs: int list) =
  if null xs
  then 0
  else hd xs * sum_list(tl xs)

fun countdown(x: int) =
  if x = 0
  then []
  else x :: countdown(x - 1)

fun factorial (n: int) =
  product_list(countdown n)

fun append (xs: int list, ys: int list) =
  if null xs
  then ys
  else (hd xs) :: append((tl xs), ys)

fun sum_pair_list(xs: (int*int) list) =
  if null xs
  then 0
  else #1 (hd xs) + #2 (hd xs) + sum_pair_list(tl xs)

fun firsts(xs: (int*int) list) =
  if null xs
  then []
  else (#1 (hd xs)) :: firsts(tl xs)

fun seconds(xs: (int*int) list) =
  if null xs
  then []
  else (#2 (hd xs)) :: seconds(tl xs)

fun sum_two_list(xs: (int*int) list, ys: (int*int) list) =
  sum_pair_list(xs) + sum_pair_list(ys)

(* let expressions *)
fun silly1(z: int) =
  let
    val x = if z > 0 then 2 else 4
  in
    if z > 0 then x + 2 else x - 2
  end

fun countup(from: int, to: int) =
  if from >= to
  then to :: []
  else from :: countup(from + 1, to)

fun countdown(from: int, to: int) =
  if from <= to
  then to :: []
  else from :: countdown(from-1, to)

(* currying *)

fun count_from1(x: int) =
  let
    fun count (from: int) =
      if from >= x
      then x :: []
      else from :: count(from+1)
  in
    count(1)
  end

(* option, a container *)
fun bad_max_list(xs: int list) =
  if null xs
  then NONE
  else if null (tl xs)
  then SOME (hd xs)
  else
    let
      val tl_ans = bad_max_list(tl xs)
    in
      if isSome tl_ans andalso valOf tl_ans > hd xs
      then tl_ans
      else SOME (hd xs)
    end

fun max_list(xs: int list) =
  if null xs
  then NONE
  else
    let
      fun max_nonempty(xs: int list) =
        if null (tl xs)
        then hd xs
        else let val tl_ans = max_nonempty(tl xs)
             in
               if tl_ans > hd xs
               then tl_ans
               else hd xs
             end
    in
      SOME (max_nonempty xs)
    end

(* start of homework 1 of programming languages mooc of University of Washington *)

fun is_older(d1: int*int*int, d2: int*int*int) =
  #1 d1 < #1 d2 orelse (#1 d1 = #1 d2 andalso #2 d1 < #2 d2) orelse (#1 d1 = #1 d2 andalso #2 d1= #2 d2 andalso #3 d1 < #3 d2)

fun number_in_month(xs: (int*int*int) list, m: int) =
  if null xs
  then 0
  else
    let
      fun in_month(x: int*int*int) = 
        if (#2 x) = m
        then 1
        else 0
    in
      in_month(hd xs) + number_in_month(tl xs, m)
    end

fun number_in_months(ds: (int*int*int) list, ms: int list) = 
  if null ms
  then 0
  else number_in_month(ds, hd ms) + number_in_months(ds, tl ms)


fun dates_in_month(ds: (int*int*int) list, m: int) =
  if null ds
  then []
  else if #2 (hd ds) = m
  then hd ds :: dates_in_month(tl ds, m)
  else dates_in_month(tl ds, m)

fun dates_in_months(ds: (int*int*int) list, ms: int list) =
  if null ms
  then []
  else
    let
      fun append(xs: (int*int*int) list, ys: (int*int*int) list) =
        if null xs
        then ys
        else hd xs :: append(tl xs, ys)
    in
      append(dates_in_month(ds, hd ms), dates_in_months(ds, tl ms))
    end

fun get_nth(s: string list, i: int) =
  if i = 1
  then hd s
  else get_nth(tl s, i - 1)

fun date_to_string(d: int*int*int) =
  let
    val m = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  in
    get_nth(m, #2 d) ^ " " ^ Int.toString(#3 d) ^ ", " ^ Int.toString(#1 d)
  end

fun number_before_reaching_sum(s: int, n: int list) =
  if s - (hd n) <= 0 orelse null n
  then 0
  else 1 + number_before_reaching_sum(s - (hd n), tl n)

fun what_month(d: int) =
  let
    val months = [31,28,31,30,31,30,31,31,30,31,30,31]
  in
    1 + number_before_reaching_sum(d, months)
  end

fun month_range(from: int, to: int) =
  if (from > to)
  then []
  else what_month(from) :: month_range(from + 1, to)

fun oldest(ds: (int*int*int) list) =
  if null ds
  then NONE
  else
    let
      fun oldest_nonempty(ds: (int*int*int) list) = 
        if null (tl ds)
        then SOME (hd ds)
        else
          let
            val tl_ans = oldest_nonempty(tl ds)
          in
            if is_older(valOf tl_ans, hd ds)
            then tl_ans
            else SOME (hd ds)
          end
    in
      oldest_nonempty(ds)
    end

(* end of homework 1 of programming languages mooc of University of Washington *)
