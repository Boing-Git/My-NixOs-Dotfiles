.pragma library 

var colors = {
    primary: {
        base: "{{colors.primary.default.hex}}",
        on: "{{colors.on_primary.default.hex}}",
        container: "{{colors.primary_container.default.hex}}",
        on_container: "{{colors.on_primary_container.default.hex}}",
        fixed: "{{colors.primary_fixed.default.hex}}",
        fixed_dim: "{{colors.primary_fixed_dim.default.hex}}",
        on_fixed: "{{colors.on_primary_fixed.default.hex}}",
        on_fixed_variant: "{{colors.on_primary_fixed_variant.default.hex}}",
        inverse: "{{colors.inverse_primary.default.hex}}"
    },
    secondary: {
        base: "{{colors.secondary.default.hex}}",
        on: "{{colors.on_secondary.default.hex}}",
        container: "{{colors.secondary_container.default.hex}}",
        on_container: "{{colors.on_secondary_container.default.hex}}",
        fixed: "{{colors.secondary_fixed.default.hex}}",
        fixed_dim: "{{colors.secondary_fixed_dim.default.hex}}",
        on_fixed: "{{colors.on_secondary_fixed.default.hex}}",
        on_fixed_variant: "{{colors.on_secondary_fixed_variant.default.hex}}"
    },
    tertiary: {
        base: "{{colors.tertiary.default.hex}}",
        on: "{{colors.on_tertiary.default.hex}}",
        container: "{{colors.tertiary_container.default.hex}}",
        on_container: "{{colors.on_tertiary_container.default.hex}}",
        fixed: "{{colors.tertiary_fixed.default.hex}}",
        fixed_dim: "{{colors.tertiary_fixed_dim.default.hex}}",
        on_fixed: "{{colors.on_tertiary_fixed.default.hex}}",
        on_fixed_variant: "{{colors.on_tertiary_fixed_variant.default.hex}}"
    },
    error: {
        base: "{{colors.error.default.hex}}",
        on: "{{colors.on_error.default.hex}}",
        container: "{{colors.error_container.default.hex}}",
        on_container: "{{colors.on_error_container.default.hex}}"
    },
    surface: {
        base: "{{colors.surface.default.hex}}",
        on: "{{colors.on_surface.default.hex}}",
        variant: "{{colors.surface_variant.default.hex}}",
        on_variant: "{{colors.on_surface_variant.default.hex}}",
        dim: "{{colors.surface_dim.default.hex}}",
        bright: "{{colors.surface_bright.default.hex}}",
        container_lowest: "{{colors.surface_container_lowest.default.hex}}",
        container_low: "{{colors.surface_container_low.default.hex}}",
        container: "{{colors.surface_container.default.hex}}",
        container_high: "{{colors.surface_container_high.default.hex}}",
        container_highest: "{{colors.surface_container_highest.default.hex}}",
        inverse: "{{colors.inverse_surface.default.hex}}",
        inverse_on: "{{colors.inverse_on_surface.default.hex}}",
        tint: "{{colors.surface_tint.default.hex}}"
    },
    outline: {
        base: "{{colors.outline.default.hex}}",
        variant: "{{colors.outline_variant.default.hex}}"
    },
    background: {
        base: "{{colors.background.default.hex}}",
        on: "{{colors.on_background.default.hex}}"
    },
    shadow: "{{colors.shadow.default.hex}}",
    scrim: "{{colors.scrim.default.hex}}"
};