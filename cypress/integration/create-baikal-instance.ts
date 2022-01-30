describe("Create Baikal instance", () => {
  it("Should initialise administrator password", () => {
    cy.visit("localhost");

    cy.get("#overview > h1").should(
      "have.text",
      "Baïkal initialization wizard"
    );
    cy.get("#admin_passwordhash").type("asdasd");
    cy.get("#admin_passwordhash_confirm").type("asdasd");
    cy.get("button[type='submit']").click();
  });

  it("Should initialise database", () => {
    cy.get("#overview > h1").should("have.text", "Baïkal Database setup");
    cy.get("button[type='submit']").click();
  });

  it("Should start Baikal", () => {
    cy.get("a.btn.btn-success")
      .should("have.text", "Start using Baïkal")
      .click();
  });

  it("Should sign in as administrator", () => {
    cy.get("input[name='password']").type("asdasd");
    cy.get("button[type='submit']").should("have.text", "Authenticate").click();
  });

  it("Should show dashboard", () => {
    cy.get("#overview > h1").should("have.text", "Dashboard");
  });
});
