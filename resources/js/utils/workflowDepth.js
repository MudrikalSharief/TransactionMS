// Breadcrumb levels for the admin workflow drill-down. The trail mirrors
// Transaction Types > [type] > Steps and Routes > [step] > page.
// Type/step levels are omitted until their ids are known, so pages can
// render the nav while their data is still loading.

const WORKFLOWS_PATH = "/admin/workflows";

function typeQuery(typeId) {
    const id = Number(typeId);
    return Number.isFinite(id) && id > 0 ? { type: id } : {};
}

function workflowsTo(typeId) {
    return {
        path: WORKFLOWS_PATH,
        query: typeQuery(typeId),
    };
}

export function workflowStepTo(name, { workflowId, stepId, typeId } = {}) {
    return {
        name,
        params: {
            workflowId: Number(workflowId),
            stepId: Number(stepId),
        },
        query: typeQuery(typeId),
    };
}

export function buildWorkflowDepthLevels({
    typeId = null,
    typeName = "",
    workflowId = null,
    stepId = null,
    stepLabel = "",
    stepTo = null,
    currentLabel = "",
    isWorkflows = false,
} = {}) {
    const levels = [
        {
            key: "types",
            label: "Transaction Types",
            to: { path: "/admin/transaction-types" },
        },
    ];

    if (typeId) {
        levels.push({
            key: `type-${typeId}`,
            label: typeName || "Transaction type",
            to: workflowsTo(typeId),
        });
    }

    if (!isWorkflows) {
        levels.push({
            key: "steps",
            label: "Steps and Routes",
            to: workflowsTo(typeId),
        });

        if (stepId) {
            levels.push({
                key: `step-${stepId}`,
                label: stepLabel || "Step",
                to:
                    stepTo ||
                    workflowStepTo("admin.step-requirements", {
                        workflowId,
                        stepId,
                        typeId,
                    }),
            });
        }
    }

    levels.push({
        key: "current",
        label: currentLabel || "Current page",
    });

    return levels;
}
