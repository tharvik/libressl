# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils multilib-minimal

DESCRIPTION="Free version of the SSL/TLS protocol forked from OpenSSL"
HOMEPAGE="http://www.libressl.org/"
SRC_URI="http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${P}.tar.gz"

LICENSE="ISC openssl"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

DEPEND="
	!dev-libs/openssl:0
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
RDEPEND="${DEPEND}"
PDEPEND="app-misc/ca-certificates"

src_prepare() {
	sed -i \
		-e '/^CFLAGS=/s#-g##' \
		-e '/^CFLAGS=/s#-Werror##' \
		-e '/^USER_CFLAGS=/s#-O2##' \
		configure || die "fixing CFLAGS failed"
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static)
}

multilib_src_test() {
	emake check
}

multilib_src_install_all() {
	einstalldocs

	# file collision with sys-apps/shadow
	rm -f "${ED%%/}"/usr/share/man/man1/passwd.1*
	newman man/passwd.1 libressl-passwd.1

	prune_libtool_files
}
