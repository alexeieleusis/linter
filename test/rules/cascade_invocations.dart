// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// test w/ `pub run test -N cascade_invocations`

//void noCascade() {
//  List<int> list = [];
//  list.removeWhere((i) => i % 5 == 0); // LINT
//  list.clear(); // LINT
//}
//
//int get someThing => 5;
//
//void noCascadeIntermediate() {
//  List<int> list = [];
//  print(list);
//  list.removeWhere((i) => i % 5 == 0);
//  list.clear(); // LINT
//}
//
//class HasMethodWithNoCascade {
//  List<int> list = [];
//
//  void noCascade() {
//    list.removeWhere((i) => i % 5 == 0);
//    list.clear(); // LINT
//  }
//}

class Foo {
  int get bar => 5;
  void baz() {}
  void foo() {}
}

void noCascadeWithGetter() {
  final foo = new Foo();
  foo.baz(); // LINT
  foo.bar; // LINT
  foo.foo(); // LINT
}

void alternatingReferences() {
  final foo = new Foo();
  final bar = new Foo();
  foo.baz();
  bar.baz();
  foo.bar;
  bar.bar;
  foo.foo();
  bar.foo();
}
