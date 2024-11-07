// modified from https://github.com/Intellicode/eslint-plugin-react-native/blob/aaefa10da25b75c77e4e43649e6b31295dd80f40/lib/rules/sort-styles.js

'use strict';

//------------------------------------------------------------------------------
// Requirements
//------------------------------------------------------------------------------

const { astHelpers } = require('eslint-plugin-react-native/lib/util/stylesheet');

const {
  getStyleDeclarationsChunks,
  getPropertiesChunks,
  getStylePropertyIdentifier,
  isStyleSheetDeclaration,
  isEitherShortHand,
} = astHelpers;

//------------------------------------------------------------------------------
// Rule Definition
//------------------------------------------------------------------------------

function create(context) {
  const order = context.options[0] || 'asc';
  const options = context.options[1] || {};
  const { ignoreClassNames } = options;
  const { ignoreStyleProperties } = options;
  const isValidOrder = order === 'asc' ? (a, b) => a <= b : (a, b) => a >= b;

  const sourceCode = context.getSourceCode();

  function sort(array) {
    // Get nodes with their associated comments
    const nodesWithComments = array.map(node => ({
      node,
      comments: sourceCode.getCommentsBefore(node),
      originalText: sourceCode.getText(node),
      range: node.range,
    }));

    // Sort the nodes while keeping comments attached
    return nodesWithComments.sort((a, b) => {
      const identifierA = getStylePropertyIdentifier(a.node);
      const identifierB = getStylePropertyIdentifier(b.node);

      if (isEitherShortHand(identifierA, identifierB)) {
        return a.range[0] - b.range[0];
      }

      let sortOrder = 0;
      if (identifierA < identifierB) {
        sortOrder = -1;
      } else if (identifierA > identifierB) {
        sortOrder = 1;
      }
      return sortOrder * (order === 'asc' ? 1 : -1);
    });
  }

  function report(array, type, node, prev, current) {
    const currentName = getStylePropertyIdentifier(current);
    const prevName = getStylePropertyIdentifier(prev);

    context.report({
      node,
      message: `Expected ${type} to be in ${order}ending order. '${currentName}' should be before '${prevName}'.`,
      loc: current.key.loc,
      fix: (fixer) => {
        // Get the sorted array with comments attached
        const sortedArrayWithComments = sort(array);

        // Find the start position of the first node or its comments
        const firstNodeStart = Math.min(...array.map(n => {
          const comments = sourceCode.getCommentsBefore(n);
          return comments.length > 0 ? comments[0].range[0] : n.range[0];
        }));
        const lastNodeEnd = Math.max(...array.map(n => n.range[1]));

        // Get the indentation by looking at the text before the first node
        const fullText = sourceCode.getText();
        const lineStartOffset = fullText.lastIndexOf('\n', firstNodeStart) + 1;
        const indentation = fullText.slice(lineStartOffset, firstNodeStart);

        // Build the new sorted text
        const newText = sortedArrayWithComments.map((item, index) => {
          let nodeText = '';

          // Add comments with proper indentation
          if (item.comments.length > 0) {
            item.comments.forEach((comment, commentIndex) => {
              // Only add indentation if it's not the first line
              if (index === 0 && commentIndex === 0) {
                nodeText += sourceCode.getText(comment) + '\n';
              } else {
                nodeText += indentation + sourceCode.getText(comment) + '\n';
              }
            });
          }

          // Add the node with proper indentation, except for first line
          if (index === 0 && item.comments.length === 0) {
            nodeText += item.originalText.trim();
          } else {
            nodeText += indentation + item.originalText.trim();
          }

          // Add comma if it's not the last item
          if (index < sortedArrayWithComments.length - 1 && !nodeText.endsWith(',')) {
            nodeText += ',';
          }
          // Remove comma if it's the last item
          if (index === sortedArrayWithComments.length - 1 && nodeText.endsWith(',')) {
            nodeText = nodeText.slice(0, -1);
          }

          return nodeText;
        }).join('\n');

        // Create a single fix for the entire range
        return fixer.replaceTextRange([firstNodeStart, lastNodeEnd], newText);
      },
    });
  }

  function checkIsSorted(array, arrayName, node) {
    for (let i = 1; i < array.length; i += 1) {
      const previous = array[i - 1];
      const current = array[i];

      if (previous.type !== 'Property' || current.type !== 'Property') {
        return;
      }

      const prevName = getStylePropertyIdentifier(previous);
      const currentName = getStylePropertyIdentifier(current);

      const oneIsShorthandForTheOther = arrayName === 'style properties' && isEitherShortHand(prevName, currentName);

      if (!oneIsShorthandForTheOther && !isValidOrder(prevName, currentName)) {
        return report(array, arrayName, node, previous, current);
      }
    }
  }

  return {
    CallExpression: function (node) {
      if (!isStyleSheetDeclaration(node, context.settings)) {
        return;
      }

      const classDefinitionsChunks = getStyleDeclarationsChunks(node);

      if (!ignoreClassNames) {
        classDefinitionsChunks.forEach((classDefinitions) => {
          checkIsSorted(classDefinitions, 'class names', node);
        });
      }

      if (ignoreStyleProperties) return;

      classDefinitionsChunks.forEach((classDefinitions) => {
        classDefinitions.forEach((classDefinition) => {
          const styleProperties = classDefinition.value.properties;
          if (!styleProperties || styleProperties.length < 2) {
            return;
          }
          const stylePropertyChunks = getPropertiesChunks(styleProperties);
          stylePropertyChunks.forEach((stylePropertyChunk) => {
            checkIsSorted(stylePropertyChunk, 'style properties', node);
          });
        });
      });
    },
  };
}

module.exports = {
  meta: {
    fixable: 'code',
    schema: [
      {
        enum: ['asc', 'desc'],
      },
      {
        type: 'object',
        properties: {
          ignoreClassNames: {
            type: 'boolean',
          },
          ignoreStyleProperties: {
            type: 'boolean',
          },
        },
        additionalProperties: false,
      },
    ],
  },
  create,
};
