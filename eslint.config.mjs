import tseslint from "typescript-eslint";
import eslintConfigPrettier from "eslint-config-prettier";

export default [...tseslint.configs.recommended, eslintConfigPrettier];
