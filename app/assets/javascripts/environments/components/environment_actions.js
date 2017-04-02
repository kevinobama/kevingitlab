/* global Flash */
/* eslint-disable no-new */

import playIconSvg from 'icons/_icon_play.svg';
import eventHub from '../event_hub';

export default {
  props: {
    actions: {
      type: Array,
      required: false,
      default: () => [],
    },

    service: {
      type: Object,
      required: true,
    },
  },

  data() {
    return {
      playIconSvg,
      isLoading: false,
    };
  },

  methods: {
    onClickAction(endpoint) {
      this.isLoading = true;

      this.service.postAction(endpoint)
      .then(() => {
        this.isLoading = false;
        eventHub.$emit('refreshEnvironments');
      })
      .catch(() => {
        this.isLoading = false;
        new Flash('An error occured while making the request.');
      });
    },
  },

  template: `
    <div class="btn-group" role="group">
      <button
        class="dropdown btn btn-default dropdown-new js-dropdown-play-icon-container"
        data-toggle="dropdown"
        :disabled="isLoading">
        <span>
          <span v-html="playIconSvg"></span>
          <i class="fa fa-caret-down" aria-hidden="true"></i>
          <i v-if="isLoading" class="fa fa-spinner fa-spin" aria-hidden="true"></i>
        </span>

      <ul class="dropdown-menu dropdown-menu-align-right">
        <li v-for="action in actions">
          <button
            @click="onClickAction(action.play_path)"
            class="js-manual-action-link no-btn">
            ${playIconSvg}
            <span>
              {{action.name}}
            </span>
          </button>
        </li>
      </ul>
    </button>
  </div>
  `,
};
