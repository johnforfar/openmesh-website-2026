{ pkgs, lib, ... }:
pkgs.buildNpmPackage {
  pname = "openmesh-website-2026";
  version = "0.1.0";
  src = ../astro-app;

  npmDeps = pkgs.importNpmLock {
    npmRoot = ../astro-app;
  };
  npmConfigHook = pkgs.importNpmLock.npmConfigHook;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{share/openmesh-website,bin}
    cp -rL dist          $out/share/openmesh-website/dist
    cp -rL node_modules  $out/share/openmesh-website/node_modules
    cp     package.json  $out/share/openmesh-website/package.json
    makeWrapper ${pkgs.nodejs_22}/bin/node $out/bin/openmesh-website \
      --add-flags "$out/share/openmesh-website/dist/server/entry.mjs" \
      --set-default PORT 3000 \
      --set-default HOST 0.0.0.0
    runHook postInstall
  '';

  doDist = false;
  meta.mainProgram = "openmesh-website";
}
