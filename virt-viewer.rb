class VirtViewer < Formula
  desc "App for virtualized guest interaction"
  homepage "https://virt-manager.org/"
  url "https://virt-manager.org/download/sources/virt-viewer/virt-viewer-11.0.tar.xz"
  sha256 "a43fa2325c4c1c77a5c8c98065ac30ef0511a21ac98e590f22340869bad9abd0"

  depends_on "bash-completion@2" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "shared-mime-info" => :build
  depends_on "spice-protocol" => :build

  depends_on "gtk-vnc"
  depends_on "libvirt"
  depends_on "libvirt-glib"
  depends_on "shared-mime-info"
  depends_on "spice-gtk"
  depends_on "vte3"

  def install
    mkdir "build" do
      args = %w[
        -Dlibvirt=enabled
        -Dvnc=enabled
        -Dspice=enabled
        -Dovirt=disabled
        -Dvte=enabled
        -Dbash_completion=enabled
      ]

      system "meson", "..", *std_meson_args, *args
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    # manual update of mime database
    system "#{Formula["shared-mime-info"].opt_bin}/update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
    # manual icon cache update step
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/virt-viewer", "--version"
  end
end
