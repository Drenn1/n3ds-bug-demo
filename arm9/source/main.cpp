#include <nds.h>
#include <dirent.h>
#include <unistd.h>
#include <stdio.h>
#include <stdarg.h>
#include <time.h>


int main(int argc, char* argv[])
{
    consoleDemoInit();
    consoleDebugInit(DebugDevice_CONSOLE);

    defaultExceptionHandler();

    while (1) {
        swiWaitForVBlank();
        int keys = keysCurrent();

        consoleClear();
        printf("Keys current: %.8x\n", keys);
    }

    return 0;
}
