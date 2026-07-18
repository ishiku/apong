#define SDL_MAIN_USE_CALLBACKS // This is necessary for the new callbacks API.
                               // To use the legacy API, don't define this.
#include <SDL3/SDL.h>
#include <SDL3/SDL_init.h>
#include <SDL3/SDL_main.h>

constexpr int kWindowInitialWidth = 800;
constexpr int kWindowInitialHeight = 600;

struct AppContext {
  SDL_Window *window;
  SDL_Renderer *renderer;
  SDL_AppResult app_quit = SDL_APP_CONTINUE;
};

SDL_AppResult SDL_Fail() {
  SDL_LogError(SDL_LOG_CATEGORY_CUSTOM, "Error %s", SDL_GetError());
  return SDL_APP_FAILURE;
}

SDL_AppResult SDL_AppInit(void **appstate, int argc, char *argv[]) {
  if (!SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO)) {
    SDL_LogError(SDL_LOG_CATEGORY_CUSTOM, "Error %s", SDL_GetError());
    return SDL_APP_FAILURE;
  }

  SDL_Window *window =
      SDL_CreateWindow("Hello SDL3", kWindowInitialWidth, kWindowInitialHeight,
                       SDL_WINDOW_RESIZABLE | SDL_WINDOW_HIGH_PIXEL_DENSITY);
  if (window == nullptr) {
    SDL_LogError(SDL_LOG_CATEGORY_CUSTOM, "Error %s", SDL_GetError());
    return SDL_APP_FAILURE;
  }

  SDL_Renderer *renderer = SDL_CreateRenderer(window, NULL);
  if (renderer == nullptr) {
    SDL_LogError(SDL_LOG_CATEGORY_CUSTOM, "Error %s", SDL_GetError());
    return SDL_APP_FAILURE;
  }

  *appstate = new AppContext{
      .window = window,
      .renderer = renderer,
  };

  SDL_SetRenderVSync(renderer, -1);
  return SDL_APP_CONTINUE;
}

SDL_AppResult SDL_AppEvent(void *appstate, SDL_Event *event) {
  auto *app = (AppContext *)appstate;

  if (event->type == SDL_EVENT_QUIT) {
    app->app_quit = SDL_APP_SUCCESS;
  }

  return SDL_APP_CONTINUE;
}

SDL_AppResult SDL_AppIterate(void *appstate) {
  auto *app = (AppContext *)appstate;

  SDL_SetRenderDrawColor(app->renderer, 255, 255, 255, SDL_ALPHA_OPAQUE);
  SDL_RenderClear(app->renderer);

  SDL_RenderPresent(app->renderer);

  return app->app_quit;
}

void SDL_AppQuit(void *appstate, SDL_AppResult result) {
  auto *app = (AppContext *)appstate;
  if (app) {
    SDL_DestroyRenderer(app->renderer);
    SDL_DestroyWindow(app->window);

    delete app;
  }

  SDL_Log("Application quit successfully!");
  SDL_Quit();
}
