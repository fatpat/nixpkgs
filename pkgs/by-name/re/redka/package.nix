{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "redka";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "nalgeon";
    repo = "redka";
    rev = "v${version}";
    hash = "sha256-Dm+QMmCYoYJWv+Crot0bwcSPHuUYQzhRgTO65jRjLLE=";
  };

  vendorHash = "sha256-aX0X6TWVEouo884LunCt+UzLyvDHgmvuxdV0wh0r7Ro=";

  subPackages = [ "cmd/redka" "cmd/cli" ];

  ldflags = [ "-X main.version=v${version}" ];

  postInstall = ''
    mv $out/bin/{cli,redka-cli}
  '';

  meta = {
    description = "Redis re-implemented with SQLite";
    homepage = "https://github.com/nalgeon/redka";
    maintainers = with lib.maintainers; [ sikmir ];
    license = lib.licenses.bsd3;
  };
}
