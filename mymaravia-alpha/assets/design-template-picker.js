(() => {
  const initPicker = (picker) => {
    if (!picker || picker.dataset.initialized === 'true') return;
    picker.dataset.initialized = 'true';

    const form = picker.closest('form');
    if (!form) return;

    const select = picker.querySelector('[data-template-select]');
    const templateInput = picker.querySelector('[data-template-input]');
    const designInput = picker.querySelector('[data-design-input]');
    const cards = Array.from(picker.querySelectorAll('[data-design-option]'));
    const error = picker.querySelector('[data-template-error]');
    const requireSelection = picker.dataset.required === 'true';

    if (!select || !templateInput || !designInput || cards.length === 0) return;

    const setActive = (card) => {
      cards.forEach((item) => {
        const isActive = item === card;
        item.classList.toggle('is-active', isActive);
        item.setAttribute('aria-pressed', isActive ? 'true' : 'false');
      });

      if (!card) return;

      const selectedTemplate = card.dataset.template || '';
      const selectedDesign = card.dataset.design || '';
      templateInput.value = selectedTemplate;
      designInput.value = selectedDesign;

      if (error) error.classList.add('hidden');
    };

    const getVisibleCards = () => cards.filter((card) => !card.hidden);

    const applyTemplateFilter = (template) => {
      cards.forEach((card) => {
        const cardTemplate = card.dataset.template || '';
        card.hidden = template !== 'all' && cardTemplate !== template;
      });

      const visibleCards = getVisibleCards();
      const activeVisible = visibleCards.find((card) => card.classList.contains('is-active'));
      setActive(activeVisible || visibleCards[0] || null);
    };

    const buildTemplateOptions = () => {
      const templates = [];
      cards.forEach((card) => {
        const value = (card.dataset.template || '').trim();
        if (value && !templates.includes(value)) templates.push(value);
      });

      if (templates.length <= 1) {
        select.value = 'all';
        templateInput.value = templates[0] || 'Standard';
        select.closest('.product-form__input')?.classList.add('hidden');
        return;
      }

      templates.forEach((template) => {
        const option = document.createElement('option');
        option.value = template;
        option.textContent = template;
        select.appendChild(option);
      });
    };

    buildTemplateOptions();
    applyTemplateFilter(select.value || 'all');

    select.addEventListener('change', () => {
      applyTemplateFilter(select.value || 'all');
    });

    cards.forEach((card) => {
      card.addEventListener('click', () => {
        if (card.hidden) return;
        const cardTemplate = card.dataset.template || 'all';
        const hasOption = Array.from(select.options).some((option) => option.value === cardTemplate);
        if (hasOption) {
          select.value = cardTemplate;
        } else {
          select.value = 'all';
        }
        applyTemplateFilter(select.value || 'all');
        setActive(card);
      });
    });

    form.addEventListener('submit', (event) => {
      if (!requireSelection) return;
      if (designInput.value) return;

      event.preventDefault();
      if (error) error.classList.remove('hidden');
      picker.scrollIntoView({ behavior: 'smooth', block: 'center' });
    });
  };

  const initAllPickers = (scope = document) => {
    scope.querySelectorAll('[data-template-picker]').forEach(initPicker);
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => initAllPickers());
  } else {
    initAllPickers();
  }

  if (window.Shopify && Shopify.designMode) {
    document.addEventListener('shopify:section:load', (event) => {
      initAllPickers(event.target);
    });
  }
})();
