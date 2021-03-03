(* Input signature of the functor *)
module type OrderedType = sig
  (* the type of the heap elements *)
  type t

  (* compare function used to determine the order of elements *)
  val compare : t -> t -> int
end

module Make : functor (Ord : OrderedType) -> sig
  type elt = Ord.t

  type tree

  (* create an empty heap, with only a leaf *)
  val create : unit -> tree

  (* merge to heap, the most important function in leftist heap *)
  val merge : tree -> tree -> tree

  (* insert an element into a heap, just like merge two heap *)
  val insert : elt -> tree -> tree

  (* get the top element of a heap *)
  val getTop : tree -> elt

  (* delete the top element of a heap, just merge two children trees *)
  val deleteTop : tree -> tree

  (* generate a list from a heap *)
  val toList : tree -> elt list

  (* create a heap from list *)
  val fromList : elt list -> tree
end
