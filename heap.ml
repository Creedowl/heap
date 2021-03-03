(* Input signature of the functor *)
module type OrderedType = sig
  (* the type of the heap elements *)
  type t

  (* compare function used to determine the order of elements *)
  val compare : t -> t -> int
end

module Make (Ord : OrderedType) = struct
  type elt = Ord.t

  (* heaps are represented by leftist tree *)
  type tree =
    (* leaf node *)
    | Leaf
    (* left child, value of node, right child, rank of node *)
    | Node of tree * elt * tree * int

  (* create an empty heap, with only a leaf *)
  let create () = Leaf

  (* create a node contains only v *)
  let singleton v = Node (Leaf, v, Leaf, 1)

  (* get the rank of a node *)
  let getRank = function Leaf -> 0 | Node (_, _, _, r) -> r

  (* merge to heap, the most important function in leftist heap *)
  let rec merge t1 t2 =
    match (t1, t2) with
    (* if one sub tree is Leaf, just return the other *)
    | Leaf, t | t, Leaf -> t
    | Node (l, v1, r, _), Node (_, v2, _, _) ->
        (* switch two heap if the tree on the left have a bigger key *)
        if Ord.compare v1 v2 > 0 then merge t2 t1
          (* the order is determined by the compare function *)
        else
          (* merge with the right tree *)
          let merged = merge r t2 in
          let leftRank = getRank l and rightRank = getRank merged in
          (* compare the rank of both tree *)
          if leftRank >= rightRank then Node (l, v1, merged, rightRank + 1)
            (* switch left and right since left tree is shorter *)
          else Node (merged, v1, l, leftRank + 1)

  (* insert an element into a heap, just like merge two heap *)
  let insert v t =
    match t with
    | Leaf -> singleton v
    | Node (_, _, _, _) -> merge t (singleton v)

  (* get the top element of a heap *)
  let getTop = function Leaf -> failwith "empty" | Node (_, v, _, _) -> v

  (* delete the top element of a heap, just merge two children trees *)
  let deleteTop = function
    | Leaf -> failwith "empty"
    | Node (l, _, r, _) -> merge l r

  (* generate a list from a heap *)
  let rec toList t =
    match t with Leaf -> [] | _ -> getTop t :: toList (deleteTop t)

  let rec fromList = function
    | [] -> create ()
    | hd :: tl -> insert hd (fromList tl)
end
