import { defineConfig } from "cypress";

let config = {
  e2e: {
    supportFile: false,
    screenshotsFolder: "cypress/screenshots",
    excludeSpecPattern: "",
  },
  reporterOptions: {
    mochaFile: "results/my-test-output.txt",
    toConsole: true,
  },
};

if (process.env.CYPRESS_MSMTP_ENABLED ?? false) {
  config.e2e.screenshotsFolder = "cypress/screenshots/msmtp";
} else {
  config.e2e.excludeSpecPattern = "**/*.msmtp.cy.ts";
}

export default defineConfig(config as Cypress.ConfigOptions);
