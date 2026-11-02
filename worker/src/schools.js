// Which email addresses count as "a student" for the 50% student discount (POST /student).
//
// An address qualifies when its domain ends in one of SCHOOL_SUFFIXES below (with at least one name in front,
// so "mit.edu" and "cs.mit.edu" count but a bare "edu" does not), or is, or is under, a domain in
// SCHOOL_ALLOWLIST. These suffixes are reserved for schools and universities by the country that runs them.
//   edu        United States colleges and universities
//   edu.XX     schools in Australia, China, Hong Kong, Singapore, Malaysia, Mexico, Brazil, Argentina,
//              Colombia, Turkey, Poland, India, Pakistan, the Philippines, Egypt, Saudi Arabia, Taiwan, and more
//   ac.XX      "academic" in the UK, Japan, New Zealand, South Africa, Korea, India, Israel, Austria,
//              Thailand, and Indonesia
// Many countries have no school-only suffix (Germany, France, Canada, Switzerland, the Netherlands...), so their
// universities go in SCHOOL_ALLOWLIST by hand. To add one, put its email domain (the part after the @) in the
// list, in lowercase, and redeploy the worker.
export const SCHOOL_SUFFIXES = [
  'edu',
  'edu.au', 'edu.cn', 'edu.hk', 'edu.sg', 'edu.my', 'edu.mx', 'edu.br', 'edu.ar', 'edu.co', 'edu.tr',
  'edu.pl', 'edu.in', 'edu.pk', 'edu.ph', 'edu.eg', 'edu.sa', 'edu.tw', 'edu.vn', 'edu.pe', 'edu.cl',
  'ac.uk', 'ac.jp', 'ac.nz', 'ac.za', 'ac.kr', 'ac.in', 'ac.il', 'ac.at', 'ac.th', 'ac.id',
];

export const SCHOOL_ALLOWLIST = [
  'utoronto.ca', 'ubc.ca', 'mcgill.ca', 'uwaterloo.ca',
  'ethz.ch', 'epfl.ch', 'uzh.ch',
  'tum.de', 'lmu.de', 'uni-heidelberg.de', 'fu-berlin.de', 'hu-berlin.de',
  'tudelft.nl', 'uva.nl', 'kuleuven.be', 'sorbonne-universite.fr',
  'ku.dk', 'kth.se', 'uio.no', 'helsinki.fi',
];

const under = (domain, base) => domain === base || domain.endsWith(`.${base}`);

export const isSchoolDomain = (domain) =>
  SCHOOL_SUFFIXES.some((s) => domain.endsWith(`.${s}`)) ||
  SCHOOL_ALLOWLIST.some((d) => under(domain, d));
