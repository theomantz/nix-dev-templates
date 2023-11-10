{
    description = "project templates";
    outputs = {...}: {
        templates = {
            java = {
                path = ./java;
                description = "Flake template for Java based projects";
            };
            latex = {
                path = ./latex;
                description = "Flake template for LaTeX projects";
            };
            python = {
                path = ./python;
                description = "Flake template for Python based projects";
            };
        };
    };
}