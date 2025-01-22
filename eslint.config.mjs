import tseslint from "typescript-eslint";
import eslintConfigPrettier, { rules } from "eslint-config-prettier";

export default [
  ...tseslint.configs.recommended,
  eslintConfigPrettier,
  // Chai assertion friendly configuration
  {
    rules: [
      {
        files: ["*.test.js", "*.spec.js"],
        rules: {
          "no-unused-expressions": "off",
        },
      },
    ],
  },
];
