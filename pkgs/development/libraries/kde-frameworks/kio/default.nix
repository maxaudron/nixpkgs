{
  stdenv, lib, mkDerivation, fetchpatch,
  extra-cmake-modules, kdoctools, qttools,
  acl, attr, libkrb5, util-linux,
  karchive, kbookmarks, kcompletion, kconfig, kconfigwidgets, kcoreaddons,
  kdbusaddons, ki18n, kiconthemes, kitemviews, kjobwidgets, knotifications,
  kservice, ktextwidgets, kwallet, kwidgetsaddons, kwindowsystem, kxmlgui,
  qtbase, qtscript, qtx11extras, solid, kcrash, kded
}:

mkDerivation {
  pname = "kio";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    karchive kconfigwidgets kdbusaddons ki18n kiconthemes knotifications
    ktextwidgets kwallet kwidgetsaddons kwindowsystem qtscript qtx11extras
    kcrash libkrb5
  ] ++ lib.lists.optionals stdenv.isLinux [
    acl attr # both are needed for ACL support
    util-linux # provides libmount
  ];
  propagatedBuildInputs = [
    kbookmarks kcompletion kconfig kcoreaddons kitemviews kjobwidgets kservice
    kxmlgui qtbase qttools solid
  ] ++ lib.optionals stdenv.isLinux [
    kded
  ];
  outputs = [ "out" "dev" ];
  patches = [
    ./0001-Remove-impure-smbd-search-path.patch

    # Fix a crash when saving files.
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/kio/-/commit/48322f44323a1fc09305d66d9093fe6c3780709e.patch";
      hash = "sha256-4NxI2mD/TdthvrzgatCAlM6VN3N38i3IJUHh0Bs8Fjk=";
    })
 ];
}
