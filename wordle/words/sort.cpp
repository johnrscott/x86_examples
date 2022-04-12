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
 */
int main()
{
    std::ifstream ifile;
    ifile.open("input.txt");
    std::vector<std::string> words{std::istream_iterator<std::string>(ifile),
				   std::istream_iterator<std::string>()};
    ifile.close();
    
    std::sort(std::begin(words), std::end(words));

    std::ofstream ofile;
    ofile.open("output.s");
    ofile << ".data" << std::endl;
    ofile << ".equiv " << "NUM_WORDS, " << words.size() << std::endl;
    ofile << ".ascii \"";
    for (const auto & str : words) {
	ofile << str << "   " ;
    }
    ofile << "\"" << std::endl;
    ofile.close();
    std::cout << "Sorted words saved to output.s" << std::endl;
}
