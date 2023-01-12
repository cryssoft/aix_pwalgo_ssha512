#
#  CLASS:       aix_pwalgo_ssha512
#
#  PURPOSE:     This trivial class is all we need (theoretically) to change the
#               systems's default password hashing algorithm to something more
#		secure and keep it that way.
#
#  PARAMETERS:  (none)
#
#  NOTES:       This does not invalidate any old passwords or force them to be
#		reset.  It just changes the algorithm from then on for LOCAL
#		IDs only.
#
#		Yes, AIX 7.3 defaults to ssha256 (salted, SHA-256) for new 
#		installs.  No, I'm not sure if upgrades in place also take
#		that default.  We (I) decided to jump past that to support
#		CyberArk's desire to manage really long passwords.
#
#-------------------------------------------------------------------------------
#
#  AUTHOR:      Chris Petersen, Crystallized Software
#
#  DATE:        February 23, 2021
#
#  LAST MOD:    (never)
#
#-------------------------------------------------------------------------------
#
#  MODIFICATIONS:
#
#       (none)
#
#-------------------------------------------------------------------------------
#
class aix_pwalgo_ssha512 {

    #  Guard application of this class
    if (($::facts['kernel'] == 'AIX') and ($::facts['aix_pwalgo'] != 'ssha512')) {

        #
        #  Sadly, this is an exec.  Not sure if there's a really good way around
        #  that, since the /etc/security/login.cfg file is a complex, stanza-
        #  based format a la AIX and may not even contain a usw: pwd_algorithm
        #  at all.
        #
        exec { 'set default AIX password hashing algorithm to ssha512':
            command  => '/usr/bin/chsec -f /etc/security/login.cfg -s usw -a "pwd_algorithm=ssha512"',
            path     => '/bin:/sbin:/usr/bin:/usr/sbin',
        }

    }

}
