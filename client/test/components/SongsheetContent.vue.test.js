import { setActivePinia, createPinia } from "pinia";
import { mount, config } from "@vue/test-utils";
import component from "@/components/SongsheetContent.vue";
import { expect, test, beforeEach } from "vitest";
import { useSongsheetParser } from "@/composables";
import * as components from "@/components";

config.global.components = components;

function render(content) {
  const { song } = useSongsheetParser(content);
  return mount(component, { props: { song: song.value } });
}

beforeEach(() => {
  setActivePinia(createPinia());
});

test("just a title", async () => {
  const wrapper = render("{title: Hello World}");
  expect(wrapper.find("h1").text()).toEqual("Hello World");
});

test("artist", async () => {
  const wrapper = render("{title: Title}\n{artist: Artist}");
  expect(wrapper.find("h2").text()).toEqual("by Artist");
});

test("multiple artists", async () => {
  const wrapper = render(
    "{title: Title}\n{artist: Artist 1}\n{artist: Artist 2}",
  );
  expect(wrapper.find("h2").text()).toEqual("by Artist 1 and Artist 2");
});

test("subtitle", async () => {
  const wrapper = render("{title: Title}\n{subtitle: Subtitle}");
  expect(wrapper.find("h2").text()).toEqual("Subtitle");
});
