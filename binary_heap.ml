(* Input signature of the functor *)
module type OrderedType = sig
  (* the type of the heap elements *)
  type t

  (* compare function used to determine the order of elements *)
  val compare : t -> t -> int
end

module Make (Ord : OrderedType) = struct
  type elt = Ord.t

  type tree = { mutable elements : elt array; mutable size : int }

  let create n default = { size = 0; elements = Array.make n default }

  let insert v t =
    let d = t.elements in
    let rec shiftUp i =
      let fi = (i - 1) / 2 in
      if i > 0 && Ord.compare d.(fi) v > 0 then (
        d.(i) <- d.(fi);
        shiftUp fi )
      else d.(i) <- v
    in
    shiftUp t.size;
    t.size <- t.size + 1

  let deleteTop t =
    if t.size <= 0 then failwith "empty"
    else
      let n = t.size - 1 in
      t.size <- n;
      let d = t.elements in
      let x = d.(n) in
      let rec shiftDown i =
        let ci = (2 * i) + 1 in
        if ci < n then
          let j =
            let k = ci + 1 in
            if k < n && Ord.compare d.(k) d.(ci) < 0 then k else ci
          in
          if Ord.compare d.(j) x < 0 then (
            d.(i) <- d.(j);
            shiftDown j )
          else d.(i) <- x
        else d.(i) <- x
      in
      shiftDown 0

  let getTop t = if t.size <= 0 then failwith "empty" else t.elements.(0)

  let rec toList t =
    if t.size <= 0 then []
    else
      let top = getTop t in
      deleteTop t;
      top :: toList t

  let rec fromList n default = function
    | [] -> create n default
    | hd :: tl ->
        let t = fromList n default tl in
        insert hd t;
        t
end
