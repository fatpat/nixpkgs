{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "spire";
  version = "1.2.0";

  outputs = [ "out" "agent" "server" ];

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = pname;
    rev = "v${version}";
    sha256 = "01ph9jzh18bnidrsbnnxm3gxh0cgfllnjvf7a5haqz51lm6a9pny";
  };

  vendorSha256 = "17d845lwlbk19lsc937c22b1l0ikimhlagknm2i7mn8s8xrs57q8";

  subPackages = [ "cmd/spire-agent" "cmd/spire-server" ];

  # Usually either the agent or server is needed for a given use case, but not both
  postInstall = ''
    mkdir -vp $agent/bin $server/bin
    mv -v $out/bin/spire-agent $agent/bin/
    mv -v $out/bin/spire-server $server/bin/

    ln -vs $agent/bin/spire-agent $out/bin/spire-agent
    ln -vs $server/bin/spire-server $out/bin/spire-server
  '';

  meta = with lib; {
    description = "The SPIFFE Runtime Environment";
    homepage = "github.com/spiffe/spire";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
