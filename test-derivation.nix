let pkgs = import <nixpkgs> {}; in
let lib  = import <nixpkgs/lib>; in with lib;
let common-path = import <nixpkgs/pkgs/stdenv/generic/common-path.nix> { inherit pkgs; }; in
let PATH_TEST = concatMapStringsSep ":" (out: (getBin out) + "/bin") common-path; in

# Create a derivation that uses bash as the builder, and the passed-in builder
# as the script that bash calls.
let drv = s: derivation (s // {
	system = builtins.currentSystem; 
	builder = "${pkgs.bash}/bin/bash";
	args = [ s.builder ]; }); in

[
(drv {
	name = "test-derivation-explicit-tools";
	# We have to get our tools into attributes, which turn into env vars
	# for the script.
	env = "${pkgs.coreutils}/bin/env";
	sort = "${pkgs.coreutils}/bin/sort";
	builder = builtins.toFile "builder.sh" "$env | $sort > $out"; 
})

(drv {
	name = "test-derivation-trivial-path";
	PATH = "${pkgs.coreutils}/bin";
	inherit PATH_TEST;
	builder = builtins.toFile "builder.sh" "env | sort > $out"; 
})
]
