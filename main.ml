(* int 型函子，带比较函数 *)
module E = struct
  type t = int

  let compare a b = -compare a b
end

(* int 型大顶堆，采用左偏树 *)
module H_int = Heap.Make (E)

let t = H_int.create ()

(* 测试基本的插入、删除等操作 *)
let () =
  let t =
    H_int.insert 3 t |> H_int.insert 5 |> H_int.insert 1 |> H_int.insert 4
    |> H_int.insert 2
  in
  assert (H_int.getTop t = 5);
  assert (H_int.deleteTop t |> H_int.deleteTop |> H_int.getTop = 3);
  List.iter (Printf.printf "%d ") (H_int.toList t);
  print_newline ()

(* 测试从 list 构建和生成 list *)
let () =
  let l = H_int.toList (H_int.fromList [ 4; 2; 1; 5; 6; 7; 2; 0 ]) in
  assert (l = [ 7; 6; 5; 4; 2; 2; 1; 0 ]);
  List.iter (Printf.printf "%d ") l;
  print_newline ()

(* 测试合并两个堆 *)
let () =
  let t =
    H_int.merge
      (H_int.fromList [ 1; 3; 5; 7; 9 ])
      (H_int.fromList [ 2; 4; 6; 8 ])
  in
  let l = H_int.toList t in
  assert (l = [ 9; 8; 7; 6; 5; 4; 3; 2; 1 ]);
  List.iter (Printf.printf "%d ") l;
  print_newline ()

(* string 型小顶堆 *)
module H_string = Heap.Make (String)

let t = H_string.create ()

(* 测试基本的插入、删除等操作 *)
let () =
  let t =
    H_string.insert "asdf" t |> H_string.insert "qwer" |> H_string.insert "zz"
  in
  assert (H_string.getTop t = "asdf");
  assert (
    H_string.toList
      (H_string.deleteTop t |> H_string.deleteTop |> H_string.insert "bb")
    = [ "bb"; "zz" ] )

(* 测试 string 类型上的操作 *)
let () =
  let l =
    H_string.toList
      (H_string.merge
         (H_string.fromList [ "Z"; "Y"; "X" ])
         (H_string.fromList [ "y"; "z"; "x" ]))
  in
  assert (l = [ "X"; "Y"; "Z"; "x"; "y"; "z" ]);
  List.iter (Printf.printf "%s ") l;
  print_newline ()

(* int 型大顶堆，采用数组模拟完全二叉树 *)
module B_H_int = Binary_heap.Make (E)

let t = B_H_int.create 20 0

(* 测试基本的插入、删除等操作 *)
let () =
  B_H_int.insert 1 t;
  B_H_int.insert 3 t;
  B_H_int.insert 2 t;
  B_H_int.insert 4 t;
  assert (B_H_int.getTop t = 4);
  B_H_int.deleteTop t;
  assert (B_H_int.getTop t = 3);
  B_H_int.deleteTop t;
  assert (B_H_int.getTop t = 2);
  B_H_int.insert 6 t;
  assert (B_H_int.getTop t = 6);
  B_H_int.deleteTop t;
  B_H_int.deleteTop t;
  assert (B_H_int.getTop t = 1)

let t = B_H_int.create 20 0

(* 测试生成 list *)
let () =
  B_H_int.insert 1 t;
  B_H_int.insert 3 t;
  B_H_int.insert 2 t;
  B_H_int.insert 4 t;
  List.iter (Printf.printf "%d ") (B_H_int.toList t);
  print_newline ()

(* 测试从 list 构建 *)
let () =
  let t = B_H_int.fromList 20 0 [ 1; 3; 5; 7; 9; 2; 4; 6; 8; 0 ] in
  assert (B_H_int.toList t = [ 9; 8; 7; 6; 5; 4; 3; 2; 1; 0 ])

(* 测试两种堆实现的结果一致 *)
let () =
  let t1 = H_int.fromList [ 1; 3; 5; 7; 9; 2; 4; 6; 8; 0 ]
  and t2 = B_H_int.fromList 20 0 [ 1; 3; 5; 7; 9; 2; 4; 6; 8; 0 ] in
  assert (H_int.toList t1 = B_H_int.toList t2)
