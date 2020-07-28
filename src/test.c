#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char check_polyAT(char* seq, int polyAT){
	if (polyAT>0){
		int seqlen = strlen(seq);
		int i,j;
		int count;
		if (seq[0] == 'A' || seq[0] == 'T') count = 1;
		for(i=1;i<seqlen;i++){
			if (seq[i]=='A' || seq[i]=='T'){
				if (seq[i] == seq[i-1]){
					count++;
					if (count == polyAT) return(1);
					continue;
				}
			}
			count = 0;
		}
	}
	return(0);
}


int main(){
	char* string ="GTCAGCTAAAAACTGTGTTTTTTTTGTTTTAAAAA";
	if (check_polyAT(string,9)){
		puts("yes");
	}

	return(1);

}
