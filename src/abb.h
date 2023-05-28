#define ABBS                                                      \
/* atomic */                                                      \
X(NILABB, "nil")    X(INTABB, "int")    X(LGLABB, "lgl")    X(DBLABB, "dbl")  \
X(STRABB, "str")    X(CHRABB, "chr")    X(CPLABB, "cpl")    X(RAWABB, "raw")  \
/* bunch */                                                       \
X(LSTABB, "lst")    X(DFRABB, "dfr")    X(DFABB, "df")      X(ENVABB, "env")  \
X(VECABB, "vec")    X(MTXABB, "mtx")    X(ARRABB, "arr")          \
X(TSABB, "ts")      X(FCTABB, "fct")    X(ORDABB, "ord")    X(TABABB, "tab")  \
/* language & programming */                                      \
X(SYMABB, "sym")    X(LNGABB, "lng")    X(CLOABB, "clo")          \
X(FUNABB, "fun")    X(EXPABB, "exp")    X(FMLABB, "fml")          \
/* supertypes */                                                  \
X(NUMABB, "num")                                                  \
/* states & values */                                             \
X(INFABB, "inf")    X(FINABB, "fin")                              \
/* object oriented */                                             \
X(S3ABB, "s3")      X(S4ABB, "s4")      X(ANYABB, "any")    X(ATMABB, "atm")  \
/* third-party */                                                 \
X(TBLABB, "tbl")                                                  \

typedef enum {
#define X(a, b) a,
  ABBS
#undef X
  NUM_ABBS
} ABB;

#define X(a, b) { a, b },
const static struct {
  const int abb;
  const char *str;
  } AbbCheckTable[] = {
    ABBS
  };
#undef X

_Static_assert(NUM_ABBS == sizeof AbbCheckTable/sizeof *AbbCheckTable, "error");
