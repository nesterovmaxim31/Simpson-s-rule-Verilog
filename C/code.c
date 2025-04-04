#include <stdio.h>
#include <string.h>

typedef unsigned short int wire;


int value(int x, int* coefficients) {
  int ans = coefficients[0] + x * coefficients[1] + \
	x * x * coefficients[2] + x * x * x * coefficients[3];
  return ans;
}

void fsm() {
  int state = 0, i = 0;
  int coefficients[] = {0, 0, 0, 0}, a = 0, b = 0;
  int result;

  /* Beginning of FSM */
  while (1) {
	switch (state) {
	case 0:
	  i = 0;
	  result = 0;
	  memset(coefficients, 0, sizeof(int) * 4);
	  state++;
	  break;

	case 1:
	  scanf("%d",&coefficients[0]);
	  state++;
	  break;

	case 2:
	  scanf("%d", &coefficients[1]);
	  state++;
	  break;
	  
	case 3:
	  scanf("%d",&coefficients[2]);
	  state++;
	  break;
	  
	case 4:
	  scanf("%d",&coefficients[3]);
	  state++;
	  break;

	case 5:
	  scanf("%d",&a);
	  state++;
	  break;
	
	case 6:
	  scanf("%d",&b);
	  state++;
	  break;

	case 7:
	  state = (a >= b) ? 13 : state + 1;
	  break;

	case 8:
	  state = ((b - a) % 2 != 0) ? state + 1 : 10;
	  break;
	case 9:
	  b--;
	  result += (value(b, coefficients) + value(b + 1, coefficients)) / 2;
	  printf("b result = %d\n", result);
	  state++;
	  break;

	case 10:	  
	  state = (b > a) ? 11 : 12;
	  break;

	case 11:
	  int k = (value(a, coefficients) +	\
		 4 * value(a + 1, coefficients) + value(a + 2, coefficients)) / 3;
	  printf("%d\n", k);
	  result += k;
	  state = 10;
	  a += 2;
	  break;

	case 12:
	  printf("result = %d\n", result);
	  state = 0;
	  break;


	case 13:
	  printf("Error. Wrong a and b");
	  state = 0;
	  break;
	}
  }
}

int main() {
  fsm();
  return 0;
}
