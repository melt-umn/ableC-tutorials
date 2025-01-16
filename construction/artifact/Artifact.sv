grammar artifact;

import edu:umn:cs:melt:ableC:concretesyntax as cst;
import edu:umn:cs:melt:ableC:drivers:compile;
import edu:umn:cs:melt:ableC:host;

parser extendedParser :: cst:Root {
  edu:umn:cs:melt:ableC:concretesyntax;
  edu:umn:cs:melt:tutorials:ableC:exponent;
}

copper_mda mdaTest(ablecParser) {
  edu:umn:cs:melt:tutorials:ableC:exponent;
}

fun main IO<Integer> ::= args::[String] = driver(args, extendedParser);
