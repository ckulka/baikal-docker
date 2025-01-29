// Test to check if PHP version is hidden in the response headers
// See https://github.com/ckulka/baikal-docker/issues/111
describe("Hidden PHP version header (#111)", () => {
  it("Should not expose PHP version", () => {
    cy.request("localhost").should((response) => {
      // eslint-disable-next-line @typescript-eslint/no-unused-expressions
      expect(response.headers["x-powered-by"], "HTTP header 'x-powered-by'").to
        .be.undefined;
    });
  });
});
