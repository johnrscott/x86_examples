#include <fstream>
#include <vector>
#include <iostream>
#include <iterator>

/**
 * \brief Simple program to sort and format a word list
 *
 * Run the program in the same directory as a list of words, line separated,
 * in a file called "input.txt". The words are sorted, then stored in an 
 * assembly file with padding so that each occupies 8 bytes.
 *
 * The current version of the word list (input.txt) comes from
 * https://gist.github.com/cfreshman/a03ef2cba789d8cf00c08f767e0fad7b
 *
 */
int main()
{
    std::ifstream ifile;
    ifile.open("input.txt");
    std::vector<std::string> words{std::istream_iterator<std::string>(ifile),
				   std::istream_iterator<std::string>()};
    ifile.close();
    
    std::sort(std::begin(words), std::end(words));

    std::ofstream output_assembly;
    output_assembly.open("output.s");
    output_assembly << ".data" << std::endl;
    output_assembly << ".equiv " << "NUM_WORDS, " << words.size() << std::endl;
    output_assembly << ".ascii \"";
    for (const auto & str : words) {
	output_assembly << str << "   " ;
    }
    output_assembly << "\"" << std::endl;
    output_assembly.close();
    std::cout << "Sorted words saved to output.s" << std::endl;
}
