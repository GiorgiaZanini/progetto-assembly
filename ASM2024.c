#include <stdio.h>

int main(){
	// VARIABILI
	int choice;  // SCELTA MENU
	int penalty = 0;  // PENALITA' PER RITARDO PRODUZIONE
	int end = 0;  // TIMER PRODUZIONE (NON PUO' ESSERE MAGGIORE DI 100)
	
	//INUTILE
	int n; // NUMERO PRODOTTI
	printf("Quanti prodotti devi inserire? ");
	scanf("%d", &n);
	printf("\n");
	//-----
	
	//INUTILE
	int mat[n][4];  // USARE STACK AL POSTO DI QUESTO
	int tmp[4];
	//-----
	
	//INUTILE
	for(int i=0; i<n; i++){
		printf("Inserisci %d Prodotto\n", i+1);
		printf("Inserisci ID: ");
		scanf("%d", &mat[i][0]);
		printf("Inserisci Durata: ");
		scanf("%d", &mat[i][1]);
		printf("Inserisci Scadenza: ");
		scanf("%d", &mat[i][2]);
		printf("Inserisci Priorita': ");
		scanf("%d", &mat[i][3]);
		printf("\n");
	}
	//-----
	
	do{
		printf("----- MENU -----\n");
		printf(" 1. EDF\n");
		printf(" 2. HPF\n");
		printf(" 3. Uscire\n");
		printf("Scegli Opzione: ");
		scanf("%d", &choice);
		if(choice == 1){  // EDF: Scadenza più vicina, in caso di parità priorità maggiore
			printf("\n- Pianificazione EDF:\n");
			
			// Bubble Sort - Ordinare per scadenza più vicina
			for(int i = 0; i<n-1; i++) {
 				for(int k = 0; k<n-1-i; k++) {
         			if(mat[k][2] > mat[k+1][2]) {
         				for(int j = 0; j<4; j++){
         					tmp[j] = mat[k][j];
         					mat[k][j] = mat[k+1][j];
         					mat[k+1][j] = tmp[j];
						}
        			}else if(mat[k][2] == mat[k+1][2]){
        				if(mat[k][3] < mat[k+1][3]){
        					for(int j = 0; j<4; j++){
         						tmp[j] = mat[k][j];
         						mat[k][j] = mat[k+1][j];
         						mat[k+1][j] = tmp[j];
							}
						}
					}
 				}
			}
			
			// Stampa a video e calcolo Conclusione e Penalità
			for(int i = 0; i<n; i++){
				printf("%d:%d\n", mat[i][0], end);
				end += mat[i][1];
				if(end > mat[i][2])
					penalty += (end-mat[i][2]) * mat[i][3];
			}
			printf("Conclusione: %d\n", end);
			printf("Penalty: %d\n", penalty);
		}
		else if(choice == 2){  // HPF: Priorità maggiore, in caso di parità scadenza più vicina
			printf("\n- Pianificazione HPF:\n");
			
			// Bubble Sort - Ordinare per priorità maggiore
			for(int i = 0; i<n-1; i++) {
 				for(int k = 0; k<n-1-i; k++) {
         			if(mat[k][3] < mat[k+1][3]) {
         				for(int j = 0; j<4; j++){
         					tmp[j] = mat[k][j];
         					mat[k][j] = mat[k+1][j];
         					mat[k+1][j] = tmp[j];
						}
        			}else if(mat[k][3] == mat[k+1][3]){
        				if(mat[k][2] > mat[k+1][2]){
        					for(int j = 0; j<4; j++){
         						tmp[j] = mat[k][j];
         						mat[k][j] = mat[k+1][j];
         						mat[k+1][j] = tmp[j];
							}
						}
					}
 				}
			}
			
			// Stampa a video e calcolo Conclusione e Penalità
			for(int i = 0; i<n; i++){
				printf("%d:%d\n", mat[i][0], end);
				end += mat[i][1];
				if(end > mat[i][2])
					penalty += (end-mat[i][2]) * mat[i][3];
			}
			printf("Conclusione: %d\n", end);
			printf("Penalty: %d\n", penalty);
		}
		else{  // ERRORE
			printf("\n- ERRORE: Puoi selezionare solo 1, 2 o 3!\n");
		}
		printf("\n");
	}while(choice != 3);
}
