<template>
  <v-app>
      <v-main>
          <component>
              <RouterView/>
          </component>
      </v-main>
  </v-app>
</template>

<script setup>

  import { RouterView } from 'vue-router';

</script>