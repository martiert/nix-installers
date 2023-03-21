{ stdenvNoCC, lib, fetchFromGitHub }:

{
  aarch64-firmware = stdenvNoCC.mkDerivation rec {
    pname = "aarch64-firmware";
    version = "9f07579ee64aba56419cfd0fbbca9f26741edc90";

    src = fetchFromGitHub {
      owner = "linux-surface";
      repo = pname;
      rev = version;
      sha256 = "Lyav0RtoowocrhC7Q2Y72ogHhgFuFli+c/us/Mu/Ugc=";
    };

    dontFixup = true;

    buildPhase = false;

    installPhase = ''
      mkdir --parent $out/lib/firmware/qcom
      cp firmware/qcom/a690_gmu.bin $out/lib/firmware/qcom
      cp firmware/qcom/a690_sqe.fw $out/lib/firmware/qcom
      cp --recursive firmware/qca $out/lib/firmware/
    '';
  };
}
