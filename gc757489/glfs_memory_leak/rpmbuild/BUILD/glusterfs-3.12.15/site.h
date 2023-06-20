/* site.h.  Generated from site.h.in by configure.  */
/*
 * Guidelines for using this file vs. configure.ac
 *
 * (1) If it already exists in configure.ac, leave it there.
 *
 * (2) If it needs to take effect at configure (not compile) time, it *needs*
 * to go in configure.ac.
 *
 * (3) If it affects file paths, which are the things most likely to be based
 * on an OS or distribution's generic filesystem hierarchy and not on a
 * particular package's definition (e.g. an RPM specfile), it should probably
 * go in configure.ac.
 *
 * (4) If it affects default sizes, limits, thresholds, or modes of operation
 * (e.g. IPv4 vs. IPv6), it should probably go here.
 *
 * (5) For anything else, is it more like the things in 3 or the things in 4?
 * Which approach is more convenient for the people who are likely to use the
 * new option(s)?  Make your best guesses, confirm with others, and go with
 * what works.
 */

/*
 * This is just an example, and a way to check whether site.h is actually being
 * included automatically.
 */
#define SITE_DOT_H_TEST		9987
