{
    description = "project templates";
    outputs = {...}: {
        templates = {
            java = {
                path = ./java;
                description = "Flake template for Java based projects";
            };
        };
    };
}