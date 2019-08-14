# Copyright
#

EAPI=7

#inherit git-r3

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocThrust"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocThrust/archive/2.6.0.tar.gz -> rocThrust-2.6.0.tar.gz"
#EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocThrust.git"
#EGIT_COMMIT="rocm-$(ver_cut 1-2)"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*
         =sci-libs/rocPRIM-${PV}"
DEPEND="${RDPEND}
	dev-util/cmake"

src_prepare() {
	cd ${S}
	eapply "${FILESDIR}/master-disable2ndfindhcc.patch"
	eapply "${FILESDIR}/rocThrust-2.6-disable-rocPRIM-download.patch"
	eapply "${FILESDIR}/rocThrust-2.6-changeHeaderInstallPath.patch"
	eapply_user
}

src_configure() {
	mkdir -p "${WORKDIR}/build/"
	cd "${WORKDIR}/build/"

	export PATH=$PATH:/usr/lib/hcc/$(ver_cut 1-2)/bin
	export hcc_DIR=/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/
	export hip_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/
	export HIP_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/
	export CXX=/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc

	cmake -DHIP_PLATFORM=hcc -DHIP_ROOT_DIR=/usr/lib/hip/$(ver_cut 1-2)/ -DBUILD_TEST=OFF -DCMAKE_INSTALL_PREFIX=/usr/ ${S}
}

src_compile() {
	cd "${WORKDIR}/build/"
	make VERBOSE=1
}

src_install() {
	cd "${WORKDIR}/build/"
	emake DESTDIR="${D}" install
}
