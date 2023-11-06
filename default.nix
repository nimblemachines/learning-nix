let pkgs = import <nixpkgs> {}; in with pkgs;

stdenv.mkDerivation {
	name = "chromebook-console-keymaps";
	src = fetchFromGitHub {
		owner = "nimblemachines";
		repo = "chromebook-keymap-generator";
		rev = "2ab09b5e1bd9f7a189561ec6a6ae5dcee88f25c1";
		hash = "sha256-Qf5uCBtiQdW4LonG5pckg5G4WYoHB6SD3NCNwAgTQpo=";
	};
	nativeBuildInputs = [ lua5_4 ];
	installPhase = ''
		mkdir -p $out/
		cp qwerty.map dvorak.map $out/
	'';
}
