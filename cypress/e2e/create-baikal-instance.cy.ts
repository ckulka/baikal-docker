describe("Create Baikal instance", () => {
  const adminCredentials = "ilovecookies"

  it("Should initialise Baikal", () => {
    cy.visit("localhost");

    cy.get("#overview > h1").should(
      "have.text",
      "Baïkal initialization wizard"
    );

    // Set administrator credentials
    cy.get("#admin_passwordhash").type(adminCredentials);
    cy.get("#admin_passwordhash_confirm").type(adminCredentials);
    cy.get("button[type='submit']").click();

    // Database setup
    cy.get("#overview > h1").should("have.text", "Baïkal Database setup");
    cy.get("button[type='submit']").click();

    // Finalise initialisation
    cy.get("a.btn.btn-success")
      .should("have.text", "Start using Baïkal")
      .click();
    cy.screenshot()
  });

  it("Should sign in as administrator", () => {
    cy.visit("localhost/admin")

    cy.get("input[name='password']").type(adminCredentials);
    cy.get("button[type='submit']").should("have.text", "Authenticate").click();

    cy.get("#overview > h1").should("have.text", "Dashboard");
    cy.screenshot()
  });
});
