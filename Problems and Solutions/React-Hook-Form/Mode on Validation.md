##### `mode: onChange | onBlur | onSubmit | onTouched | all = 'onSubmit'`!React Native: compatible with Controller

This option allows you to configure the validation strategy before a user submits the form. The validation occurs during the `onSubmit` event, which is triggered by invoking the [`handleSubmit`](https://www.react-hook-form.com/api/useform/handlesubmit/) function.

|Name|Type|Description|
|---|---|---|
|onSubmit|string|Validation is triggered on the `submit` event, and inputs attach `onChange` event listeners to re-validate themselves.|
|onBlur|string|Validation is triggered on the `blur` event.|
|onChange|string|Validation is triggered on the `change`event for each input, leading to multiple re-renders. Warning: this often comes with a significant impact on performance.|
|onTouched|string|Validation is initially triggered on the first `blur` event. After that, it is triggered on every `change` event.<br><br>**Note:** when using with `Controller`, make sure to wire up `onBlur` with the `render` prop.|
|all|string|Validation is triggered on both `blur` and `change` events.|

##### `reValidateMode: onChange | onBlur | onSubmit = 'onChange'`!React Native: Custom register or using Controller

This option allows you to configure validation strategy when inputs with errors get re-validated **after** a user submits the form (`onSubmit` event and [`handleSubmit`](https://www.react-hook-form.com/api/useform/handlesubmit/) function executed). By default, re-validation occurs during the input change event.